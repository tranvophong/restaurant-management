namespace ServeSys.API.Modules.Order.Entities;

public enum OrderItemStatus
{
    Pending,   // Chờ bếp
    Preparing, // Đang làm
    Served,    // Đã mang ra
    Cancelled  // Huỷ món
}

public class OrderItem
{
    public int Id { get; set; }

    public int Quantity { get; set; }

    /// <summary>Đơn giá tại thời điểm đặt (snapshot, không đổi khi menu thay đổi)</summary>
    public decimal UnitPrice { get; set; }

    /// <summary>Thành tiền = Quantity × UnitPrice</summary>
    public decimal SubTotal => Quantity * UnitPrice;

    /// <summary>Ghi chú riêng cho món này (vd: "Không hành", "Ít cay")</summary>
    public string? Notes { get; set; }
    public string StaffName { get; set; } = string.Empty;
    public string StaffId { get; set; } = string.Empty;

    public OrderItemStatus Status { get; set; } = OrderItemStatus.Pending;

    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    // Foreign keys
    public int OrderId { get; set; }
    public Order Order { get; set; } = null!;

    public int MenuItemId { get; set; }
    public MenuItem MenuItem { get; set; } = null!;
}
