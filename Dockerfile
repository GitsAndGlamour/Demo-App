FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

# copy google cloud quickstart.sh
FROM alpine
COPY quickstart.sh /
CMD ["/quickstart.sh"]

# copy csproj and restore as distinct layers
COPY *.sln .
COPY demoapp/*.csproj ./demoapp/
RUN dotnet restore

# copy everything else and build app
COPY demoapp/. ./demoapp/
WORKDIR /app/demoapp
RUN dotnet publish -c Release -o out

# Install any necessary dependencies
RUN pip install -r requirements.txt

FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/demoapp/ ./
ENTRYPOINT ["dotnet", "demoapp.dll"]
