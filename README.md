# ega-file-uploader-docker

> [!IMPORTANT]
> **NO LONGER MAINTAINED:** It appears the EGACryptor + upload via aspera workflow is no longer supported by the new EGA submitter portal launched in September 2023. Therefore, this repository has been archived and will no longer be maintained.

```
docker run --rm -it \
  -v <path_to_work_dir>:/work \
  -e ASPERA_SCP_USER=ega-box-XXX \
  -e ASPERA_SCP_PASS=XXX \
  ah3inz3l/ega \
  encrypt \
  upload \
  -i /work/input \
  -o /work/<my_out> \
  -t 4
```
