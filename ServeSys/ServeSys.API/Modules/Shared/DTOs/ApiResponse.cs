namespace ServeSys.API.Modules.Shared.DTOs;

public class ApiResponse<T>
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public T? Data { get; set; }
    
    // Chứa danh sách lỗi chi tiết
    public object? Errors { get; set; }

    public static ApiResponse<T> Ok(T? data, string message = "Success")
    {
        return new ApiResponse<T> { Success = true, Message = message, Data = data };
    }

    public static ApiResponse<T> Fail(string message, object? errors = null)
    {
        return new ApiResponse<T> { Success = false, Message = message, Errors = errors };
    }
}

public class ApiResponse
{
    public static ApiResponse<T> Ok<T>(T data, string message = "Success")
       => ApiResponse<T>.Ok(data, message);

    public static ApiResponse<object> Fail(string message, object? errors = null)
        => ApiResponse<object>.Fail(message, errors);
}
