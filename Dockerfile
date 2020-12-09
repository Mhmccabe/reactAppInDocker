FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://*:5000:

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Azure_Container_instance.csproj", "./"]
RUN dotnet restore "Azure_Container_instance.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Azure_Container_instance.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Azure_Container_instance.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Azure_Container_instance.dll"]
