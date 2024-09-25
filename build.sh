registry=${REGISTRY:-rejetto/hfs}
version=$VERSION
is_latest=${IS_LATEST:-0}

if [ -z "$version" ]; then echo "provide VERSION env"; exit 1; fi

image="$registry:$version"
latest="$registry:latest"
latest_command=
if [[ "$is_latest" -eq "1" ]]; then
  latest_command="-t $registry:latest"
fi
docker system prune -f
docker rmi "$image"
docker system prune -f
docker buildx create --name bld --use
docker buildx inspect bld --bootstrap
docker buildx build \
    --progress plain \
    --build-arg VERSION="$version" \
    --platform linux/amd64,linux/arm64 \
    -t "$image" $latest_command\
    --build-arg version=$version \
    --push .
docker buildx rm bld
docker rmi "$image"
