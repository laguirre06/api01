FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
WORKDIR /src
COPY ["api01.csproj", "./"]
RUN dotnet restore "api01.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "api01.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "api01.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "api01.dll"]
