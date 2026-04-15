namespace ServeSys.API.Modules.Table.Entities
{
    public enum AreaStatus
    {
        Active,     // Khu vực đang hoạt động, có thể đặt bàn
        Inactive    // Khu vực tạm ngưng, không thể đặt bàn
    }

    public class Area
    {
        public int Id { get; set; }
        /// <summary>Tên khu vực, vd: "Tầng 1", "Ngoài trời"</summary>
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        public short Order { get; set; } // Thứ tự hiển thị khu vực trong danh sách
        public AreaStatus Status { get; set; } = AreaStatus.Active;
        // Navigation
        public ICollection<DiningTable> DiningTables { get; set; } = new List<DiningTable>();
    }
}
