namespace ServeSys.API.Modules.Order.Entities;

public class MenuItem
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    /// <summary>Giá tại thời điểm hiện tại (snapshot được lưu vào OrderItem khi đặt món)</summary>
    public decimal Price { get; set; }

    public string? ImageUrl { get; set; }

    public int DisplayOrder { get; set; }

    public bool IsAvailable { get; set; } = true;

    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    // Foreign key
    public int MenuCategoryId { get; set; }
    public MenuCategory MenuCategory { get; set; } = null!;
}
