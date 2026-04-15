namespace ServeSys.API.Modules.Order.Entities;

public class MenuCategory
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    /// <summary>Thứ tự hiển thị trên menu (1 = đầu tiên)</summary>
    public int DisplayOrder { get; set; }

    public bool IsActive { get; set; } = true;

    public DateTime CreatedAt { get; set; }

    // Navigation
    public ICollection<MenuItem> MenuItems { get; set; } = new List<MenuItem>();
}
