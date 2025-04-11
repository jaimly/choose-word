# /bin/bash

# 预备 git、docker 命令

# 下载带用户名和密码的链接
# git clone https://github.com/jaimly/choose-word.git
# git remote set-url origin https://github.com/jaimly/choose-word.git

Project=choose-word

# 设置项目名、端口
read -p "请输入端口:" Port
read -p "是否build前端文件:" IS_BUILD
read -p "是否Docker部署:" IS_DOCKER

# 更新代码
git pull origin master
echo "更新代码成功"

# 判断是否需要npm
cp package.json package.json1
package1_md5=`md5sum package.json1 | awk '{ print $1 }'`
package_md5=`md5sum package.json | awk '{ print $1 }'`
if [ ! -d "node_modules" ] || [ $package1_md5 != $package_md5 ]; then
    npm i --production --ignore-scripts
fi
rm -rf package.json1
echo "npm成功"

# 判断是否需要build前端
if [[ $IS_BUILD == 1 ]]; then
    npm run build
    echo "build前端成功"
fi

if [[ $IS_DOCKER != 1 ]]; then 
    exit
fi

# 生成Dockerrile文件
rm -rf Dockerfile
echo "FROM node:18" >> Dockerfile
echo "ENV NODE_ENV production" >> Dockerfile
echo "WORKDIR /app" >> Dockerfile
echo "COPY . /app/" >> Dockerfile
echo "CMD npm run preview" >> Dockerfile
echo "生成DockerFile文件"

# 停止并删除容器
docker rm -f ${Project}
# 删除镜像
docker rmi ${Project}
# 生成镜像
docker build -t ${Project} .
# 启动容器
docker run -d --name ${Project} --restart=always -p $Port:3000 ${Project}