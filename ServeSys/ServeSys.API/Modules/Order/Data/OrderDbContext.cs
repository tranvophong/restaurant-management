using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Identity.Entities;
using ServeSys.API.Modules.Order.Entities;
using ServeSys.API.Modules.Table.Entities;

namespace ServeSys.API.Modules.Order.Data;

public class OrderDbContext : DbContext
{
    public OrderDbContext(DbContextOptions<OrderDbContext> options)
        : base(options)
    {
    }

    public DbSet<Entities.Order> Orders { get; set; }
    public DbSet<OrderItem> OrderItems { get; set; }
    public DbSet<MenuCategory> MenuCategories { get; set; }
    public DbSet<MenuItem> MenuItems { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // ── Order ─────────────────────────────────────────────────────────────
        modelBuilder.Entity<Entities.Order>(entity =>
        {
            entity.ToTable("Orders");
            entity.HasKey(o => o.Id);

            entity.Property(o => o.OrderCode)
                  .IsRequired()
                  .HasMaxLength(30);

            entity.HasIndex(o => o.OrderCode).IsUnique();

            entity.Property(o => o.Status)
                  .HasConversion<string>()
                  .HasMaxLength(20);

            entity.Property(o => o.Notes)
                  .HasMaxLength(500);

            entity.Property(o => o.TotalAmount)
                  .HasPrecision(18, 2);

            entity.Property(o => o.StaffName)
                  .IsRequired()
                  .HasMaxLength(100);

            entity.Property(o => o.StaffId)
                  .IsRequired()
                  .HasMaxLength(450);

            entity.Property(o => o.CreatedAt)
                  .HasDefaultValueSql("GETUTCDATE()");

            // ── Shadow Relationship DiningTable ───────────────────────────────────────
            entity.HasOne<DiningTable>()
                  .WithMany()
                  .HasForeignKey(o => o.DiningTableId)
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne<User>()
                  .WithMany()
                  .HasForeignKey(o => o.StaffId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // ── OrderItem ─────────────────────────────────────────────────────────
        modelBuilder.Entity<OrderItem>(entity =>
        {
            entity.ToTable("OrderItems");
            entity.HasKey(i => i.Id);

            entity.Property(i => i.Quantity).IsRequired();

            entity.Property(i => i.UnitPrice)
                  .HasPrecision(18, 2)
                  .IsRequired();

            // Bỏ qua computed property
            entity.Ignore(i => i.SubTotal);

            entity.Property(i => i.Notes)
                  .HasMaxLength(300);

            entity.Property(i => i.Status)
                  .HasConversion<string>()
                  .HasMaxLength(20);

            entity.Property(o => o.StaffName)
                  .IsRequired()
                  .HasMaxLength(100);

            entity.Property(o => o.StaffId)
                  .IsRequired()
                  .HasMaxLength(450);

            entity.Property(i => i.CreatedAt)
                  .HasDefaultValueSql("GETUTCDATE()");

            // Một order có nhiều item
            entity.HasOne(i => i.Order)
                  .WithMany(o => o.OrderItems)
                  .HasForeignKey(i => i.OrderId)
                  .OnDelete(DeleteBehavior.Cascade);

            // Mỗi item liên kết đến một MenuItem (không dùng cascade để giữ lịch sử)
            entity.HasOne(i => i.MenuItem)
                  .WithMany()
                  .HasForeignKey(i => i.MenuItemId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // ── MenuCategory ──────────────────────────────────────────────────────
        modelBuilder.Entity<MenuCategory>(entity =>
        {
            entity.ToTable("MenuCategories");
            entity.HasKey(c => c.Id);

            entity.Property(c => c.Name)
                  .IsRequired()
                  .HasMaxLength(100);

            entity.Property(c => c.Description)
                  .HasMaxLength(500);

            entity.Property(c => c.CreatedAt)
                  .HasDefaultValueSql("GETUTCDATE()");

            entity.HasIndex(c => c.Name).IsUnique();
        });

        // ── MenuItem ──────────────────────────────────────────────────────────
        modelBuilder.Entity<MenuItem>(entity =>
        {
            entity.ToTable("MenuItems");
            entity.HasKey(i => i.Id);

            entity.Property(i => i.Name)
                  .IsRequired()
                  .HasMaxLength(150);

            entity.Property(i => i.Description)
                  .HasMaxLength(1000);

            entity.Property(i => i.Price)
                  .HasPrecision(18, 2)
                  .IsRequired();

            entity.Property(i => i.ImageUrl)
                  .HasMaxLength(300);

            entity.Property(i => i.CreatedAt)
                  .HasDefaultValueSql("GETUTCDATE()");

            entity.Property(i => i.IsBestSeller)
                  .HasDefaultValue(false);
            // Một danh mục có nhiều món
            entity.HasOne(i => i.MenuCategory)
                  .WithMany(c => c.MenuItems)
                  .HasForeignKey(i => i.MenuCategoryId)
                  .OnDelete(DeleteBehavior.Restrict); // Không cho xóa category nếu còn món
        });

        // ── Shadow entities – chỉ dùng để EF Core resolve FK, KHÔNG tạo bảng ──
        // bảng đã được tạo bởi TableDbContext,
        // OrderDbContext cần biết schema để sinh đúng FK constraint.
        modelBuilder.Entity<DiningTable>()
                    .ToTable("DiningTables", t => t.ExcludeFromMigrations());

        modelBuilder.Entity<Area>()
                    .ToTable("Areas", t => t.ExcludeFromMigrations());

        modelBuilder.Entity<User>(entity =>
        {
            entity.ToTable("Users", t => t.ExcludeFromMigrations());
            entity.Ignore(u => u.RefreshTokens);
        });

        modelBuilder.Entity<RefreshToken>()
                    .ToTable("RefreshTokens", t => t.ExcludeFromMigrations());
    }
}
