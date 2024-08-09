arch="amd64"
push=0
image_prefix="rejetto/hfs"


function usage() {
    echo "$0 -v,--version TAG [--arm] [--push] [-p,--image-prefix PRE] [-h,--help]"
}
while true; do
    case "$1" in
        -v|--version) version="$2"; shift 2; ;;
        -h|--help) usage; exit; shift; ;;
        -p|--image-prefix) image_prefix="$2"; shift 2; ;;
        --arm) arch="arm64"; shift; ;;
        --push) push=1; shift; ;;
        --) shift; break; ;;
        *) break; ;;
    esac
done

if [ -z "$version" ]; then echo "missing version"; exit 1; fi
image="$image_prefix:$version"
if [[ "$arch" == "arm64" ]]; then image="$image-arm"; fi
docker rmi "$image"
docker system prune -f
docker build --no-cache --platform=linux/$arch -t "$image" --build-arg arch=$arch --build-arg version=$version .
if [ "$push" -eq 1 ]; then
    docker push "$image"
fi
# docker run -it rejetto/hfs:0.53.0 sh