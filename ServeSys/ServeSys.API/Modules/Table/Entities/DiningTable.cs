namespace ServeSys.API.Modules.Table.Entities;

public enum TableStatus
{
    Available,   // Bàn trống
    Occupied,    // Bàn đang có khách
    Reserved,    // Bàn đã đặt trước
    Cleaning     // Bàn đang dọn dẹp
}

public class DiningTable
{
    public int Id { get; set; }

    /// <summary>Tên/số hiệu bàn, vd: "B01", "VIP-1"</summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>Số ghế tối đa của bàn</summary>
    public int Capacity { get; set; }

    /// <summary>Khu vực / tầng của bàn</summary>
    public int AreaId { get; set; }

    public TableStatus Status { get; set; } = TableStatus.Available;

    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    // Navigation
    public Area Area { get; set; } = null!;
}
