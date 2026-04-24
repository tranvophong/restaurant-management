using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Order.Data;
using ServeSys.API.Modules.Order.Interfaces;
using ServeSys.API.Modules.Order.Interfaces.Repositories;
using ServeSys.API.Modules.Order.Repositories;
using ServeSys.API.Modules.Order.Services;

namespace ServeSys.API.Modules.Order;

public static class OrderModule
{
    public static IServiceCollection AddOrderModule(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddDbContext<OrderDbContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

        services.RegisterOrderRepositories();
        services.RegisterOrderServices();
        return services;
    }

    public static IServiceCollection RegisterOrderServices(this IServiceCollection services)
    {
        services.AddScoped<IMenuService, MenuService>();
        return services;
    }

    public static IServiceCollection RegisterOrderRepositories(this IServiceCollection services)
    {
        services.AddScoped<IMenuRepository, MenuRepository>();
        return services;
    }

    public static async Task SeedOrderModuleAsync(this WebApplication app)
    {
        using var scope = app.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<OrderDbContext>();
        await OrderModuleSeeder.SeedAsync(dbContext);
    }
}
