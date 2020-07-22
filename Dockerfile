FROM golang AS build-env
ADD . /go/src/app
WORKDIR /go/src/app
RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN go get -u -v github.com/zhouxinchao/k8stest
RUN k8stest sync
RUN GOOS=linux GOARCH=386 go build -v -o /go/src/app/app-server

FROM alpine
RUN apk add -U tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
COPY --from=build-env /go/src/app/app-server /usr/local/bin/app-server
EXPOSE 8080
CMD [ "app-server" ]