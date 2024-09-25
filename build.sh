registry=${REGISTRY:-rejetto/hfs}
version=$VERSION
is_latest=${IS_LATEST:-0}

if [ -z "$version" ]; then echo "provide VERSION env"; exit 1; fi

image="$registry:$version"
latest="$registry:latest"

docker system prune -f
docker rmi "$image"
docker system prune -f
docker buildx create --name bld --use
docker buildx inspect bld --bootstrap
docker buildx build \
    --progress plain \
    --build-arg VERSION="$version" \
    --platform linux/amd64,linux/arm64 \
    -t "$image" \
    --build-arg version=$version \
    --push .

if [[ "$is_latest" -eq "1" ]]; then
  docker pull "$image"
  docker tag "$image" "$latest"
  docker push "$latest"
fi
docker buildx rm bld
docker rmi "$image"
