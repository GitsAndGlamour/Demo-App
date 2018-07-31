FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY demoapp/*.csproj ./demoapp/

# copy everything else and build app
COPY demoapp/. ./demoapp/
WORKDIR /app/demoapp

FROM microsoft/aspnetcore:1.0.1
WORKDIR /app
COPY --from=build /app/demoapp/ ./
ENTRYPOINT ["dotnet", "demoapp.dll"]