# ega-file-uploader-docker

> [!IMPORTANT]
> **NO LONGER MAINTAINED:** It appears the EGACryptor + upload via aspera workflow is no longer supported by the new EGA submitter portal launched in September 2023. Therefore, this repository has been archived and will no longer be maintained.
> 
> The new submitter portal relies on Crypt4GH for encrypting the data prior to upload. The docker image maintained in [ega-file-uploader-c4gh-docker repository](https://github.com/aheinzel/ega-file-uploader-c4gh-docker) provides the ability to encrypt the data with Crypt4GH and to upload them to the EGA submitter portal (EGA inbox).


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
