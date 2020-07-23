FROM golang AS build-env
ENV GO111MODULE on
RUN go env -w GOPROXY=https://goproxy.cn,direct
ADD . /go/src/app
WORKDIR /go/src/app
ADD go.mod .
ADD go.sum .
RUN go mod download
RUN GOOS=linux CGO_ENABLED=0 go build -v -o /go/src/app/app-server

FROM alpine
#设置时区
RUN apk add -U tzdata
# ln -sf   a b b—>a即b 指向a 类似windows快捷方式
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
COPY --from=build-env /go/src/app/app-server /usr/local/bin/app-server
EXPOSE 8080
CMD [ "app-server" ]