using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Order.Data;

namespace ServeSys.API.Modules.Order;

public static class OrderModule
{
    public static IServiceCollection AddOrderModule(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddDbContext<OrderDbContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

        return services;
    }

    public static async Task SeedOrderModuleAsync(this WebApplication app)
    {
        using var scope = app.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<OrderDbContext>();
        await OrderModuleSeeder.SeedAsync(dbContext);
    }
}
