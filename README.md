# README

 Simple file uploader API that accepts a Mulitpart file upload and returns the response in JSON. Stores files locally under public/stored_images(also declared in .gitignore) which automatically gets generated.

* Rails version 5.1.4

* Enabled CORS for easy plug and play

* Unit/Integration Testing done with Rspec

* Sample tests using Postman with Ajax....

### GET /images

```
var settings = {
  "async": true,
  "crossDomain": true,
  "url": "http://localhost:3000/images",
  "method": "GET",
  "headers": {
    "cache-control": "no-cache",
    "postman-token": "864574e9-edab-da6f-9a3c-a231900e0d2e"
  }
}
```
```
$.ajax(settings).done(function (response) {
  console.log(response);
});
```
### POST /images

```
var form = new FormData();
form.append("image", "Ben.png");

var settings = {
  "async": true,
  "crossDomain": true,
  "url": "http://localhost:3000/images",
  "method": "POST",
  "headers": {
    "cache-control": "no-cache",
    "postman-token": "d9377640-0085-f85b-f4a1-614a94acdbf7"
  },
  "processData": false,
  "contentType": false,
  "mimeType": "multipart/form-data",
  "data": form
}

$.ajax(settings).done(function (response) {
  console.log(response);
});
```
