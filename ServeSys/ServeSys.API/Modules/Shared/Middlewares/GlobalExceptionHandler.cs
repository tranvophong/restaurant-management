using System.Net;
using System.Text.Json;
using Microsoft.AspNetCore.Diagnostics;
using ServeSys.API.Modules.Shared.DTOs;

namespace ServeSys.API.Modules.Shared.Middlewares;

public class GlobalExceptionHandler : IExceptionHandler
{
    private readonly ILogger<GlobalExceptionHandler> _logger;
    private readonly IHostEnvironment _env;

    public GlobalExceptionHandler(ILogger<GlobalExceptionHandler> logger, IHostEnvironment env)
    {
        _logger = logger;
        _env = env;
    }

    public async ValueTask<bool> TryHandleAsync(HttpContext httpContext, Exception exception, CancellationToken cancellationToken)
    {
        // 1. Ghi log Toàn Bộ chi tiết lỗi vào Console / File để tra cứu
        _logger.LogError(exception, "Lỗi hệ thống nghiêm trọng tại đường dẫn: {Path}", httpContext.Request.Path);

        // 2. Chặn lỗi rò rỉ và chuẩn bị Format Response ra ngoài Client
        var response = ApiResponse<object>.Fail(
            // Nếu Môi trường là Production -> Giấu lỗi thật đi
            _env.IsProduction() 
                ? "Hệ thống đang gặp sự cố, vui lòng thử lại sau!" 
                : exception.Message
        );

        // 3. Trả về cho Client
        httpContext.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
        httpContext.Response.ContentType = "application/json";

        var options = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
        var jsonResponse = JsonSerializer.Serialize(response, options);

        await httpContext.Response.WriteAsync(jsonResponse, cancellationToken);

        return true;
    }
}
