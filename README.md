
## terraform

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
