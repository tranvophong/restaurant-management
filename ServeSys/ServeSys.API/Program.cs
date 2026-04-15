using Microsoft.OpenApi.Models;
using ServeSys.API.Modules.Identity;
using ServeSys.API.Modules.Order;
using ServeSys.API.Modules.Shared.Middlewares;
using ServeSys.API.Modules.Table;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddExceptionHandler<GlobalExceptionHandler>();
builder.Services.AddProblemDetails();

// Đăng ký toàn bộ cấu hình từ Identity Module 
builder.Services.AddIdentityModule(builder.Configuration);

// Đăng ký Table Module (DiningTable, Seat)
builder.Services.AddTableModule(builder.Configuration);

// Đăng ký Order Module (Order, OrderItem, MenuCategory, MenuItem)
builder.Services.AddOrderModule(builder.Configuration);

// Learn more about configuring Swagger/OpenAPI
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "ServeSys API", Version = "v1" });

    // Cấu hình Swagger để nhập JWT Token
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Nhập JWT Token ở bên dưới.\nVí dụ: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] {}
        }
    });
});

var app = builder.Build();

// Seed dữ liệu khởi tạo cho các module
await app.SeedTableModuleAsync();
await app.SeedOrderModuleAsync();

app.UseExceptionHandler();
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
