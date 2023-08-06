# ega-file-uploader-docker

```
docker run --rm -it \
  -v <path_to_work_dir>:/work \
  -e ASPERA_SCP_USER=ega-box-XXX \
  -e ASPERA_SCP_PASS=XXX \
  aheinzel/ega \
  encrypt \
  upload \
  -i /work/input \
  -o /work/<my_out> \
  -t 4
```
