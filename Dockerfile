FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
LABEL maintainer "Kelvin Lu"
WORKDIR /build

# copy and build everything else
COPY . .



# Clean all projects
RUN MSBuild "Wallboard.sln" /t:Clean /m /nologo /noconsolelogger

# Publish Wallboard
RUN MSBuild "WallboardMobileApp/Wallboard/Wallboard.csproj"                                /m /p:DeployOnBuild=true /p:PublishProfile=FolderProfile


FROM mcr.microsoft.com/dotnet/framework/runtime:4.8 AS runtime
LABEL maintainer "Kelvin Lu"
WORKDIR /release

COPY --from=build /build/WallboardMobileApp/bin/app.publish                ./WallboardMobileApp
