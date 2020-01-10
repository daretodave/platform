# platform
follow steps in order
# 00
- Enable [CNRM](https://console.developers.google.com/apis/library/cloudresourcemanager.googleapis.com)
- Enable [GCE](https://console.developers.google.com/apis/library/compute.googleapis.com)
- Enable [GKE](https://console.developers.google.com/apis/library/container.googleapis.com)


From the /terraform folder -

### bash
```bash
export GOOGLE_CLOUD_KEYFILE_JSON=".."
```
```
export GOOGLE_CLOUD_TF_BUCKET=".."
```
```bash
terraform init \
    -backend-config="bucket=$GOOGLE_CLOUD_TF_BUCKET" \
    -backend-config="credentials=$GOOGLE_CLOUD_KEYFILE_JSON"
```

```bash
terraform apply
```

### powershell

```powershell
$GOOGLE_CLOUD_KEYFILE_JSON="..."
```

```powershell
$GOOGLE_CLOUD_TF_BUCKET="..."
```

```powershell
terraform init `
    -backend-config="bucket=$GOOGLE_CLOUD_TF_BUCKET" `
    -backend-config="credentials=$GOOGLE_CLOUD_KEYFILE_JSON"
```

```powershell
terraform apply
```


----

# 01
```bash
kubectl apply -f service/cnrm/
kubectl apply -f service/www/
```
