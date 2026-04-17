using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Table.Data;
using ServeSys.API.Modules.Table.Interfaces;
using ServeSys.API.Modules.Table.Interfaces.Repositories;
using ServeSys.API.Modules.Table.Repositories;
using ServeSys.API.Modules.Table.Services;

namespace ServeSys.API.Modules.Table;

public static class TableModule
{
    public static IServiceCollection AddTableModule(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddDbContext<TableDbContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

        // Đăng ký các dịch vụ liên quan đến Table
        services.RegisterTableServices();
        services.RegisterTableRepositories();
        return services;
    }

    public static IServiceCollection RegisterTableServices(this IServiceCollection services)
    {
        services.AddScoped<IAreaService, AreaService>();
        services.AddScoped<ITableService, TableService>();
        return services;
    }

    public static IServiceCollection RegisterTableRepositories(this IServiceCollection services)
    {
        services.AddScoped<ITableRepository, TableRepository>();
        return services;
    }

    public static async Task SeedTableModuleAsync(this WebApplication app)
    {
        using var scope = app.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<TableDbContext>();
        await TableModuleSeeder.SeedAsync(dbContext);
    }
}
