using ServeSys.API.Modules.Table.Entities;

namespace ServeSys.API.Modules.Order.Entities;

public enum OrderStatus
{
    Pending,    // Vừa tạo, chờ bếp xác nhận
    Confirmed,  // Bếp đã nhận
    Preparing,  // Đang chế biến
    Served,     // Đã phục vụ
    Completed,  // Hoàn thành, đã thanh toán
    Cancelled   // Huỷ
}

public class Order
{
    public int Id { get; set; }

    /// <summary>Mã order hiển thị (vd: ORD-20260329-001)</summary>
    public string OrderCode { get; set; } = string.Empty;

    public OrderStatus Status { get; set; } = OrderStatus.Pending;


    /// <summary>Ghi chú của khách hoặc nhân viên</summary>
    public string? Notes { get; set; }

    /// <summary>Tổng tiền (tính lại từ OrderItems)</summary>
    public decimal TotalAmount { get; set; }
    public string StaffName { get; set; } = string.Empty;
    public string StaffId { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    // ── Bàn ─────────────────────────────────────────────────────────────────
    public int DiningTableId { get; set; }

    // Navigation
    public ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
}
