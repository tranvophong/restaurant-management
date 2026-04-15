using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Table.Entities;

namespace ServeSys.API.Modules.Table.Data;

public class TableDbContext : DbContext
{
    public TableDbContext(DbContextOptions<TableDbContext> options)
        : base(options)
    {
    }

    public DbSet<DiningTable> DiningTables { get; set; }
    public DbSet<Area> Areas { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // ── DiningTable ──────────────────────────────────────────────────────
        modelBuilder.Entity<DiningTable>(entity =>
        {
            entity.ToTable("DiningTables");
            entity.HasKey(t => t.Id);

            entity.Property(t => t.Name)
                  .IsRequired()
                  .HasMaxLength(50);

            entity.Property(t => t.Status)
                  .HasConversion<string>()
                  .HasMaxLength(20);

            entity.Property(t => t.CreatedAt)
                  .HasDefaultValueSql("GETUTCDATE()");

            entity.HasIndex(t => t.Name).IsUnique();
            // Navigation
            entity.HasOne(t => t.Area)
                  .WithMany(a => a.DiningTables)
                  .HasForeignKey(t => t.AreaId);
        });

        // ── Area ──────────────────────────────────────────────────────
        modelBuilder.Entity<Area>(entity =>
        {
            entity.ToTable("Areas");
            entity.HasKey(a => a.Id);
            entity.Property(a => a.Name)
                  .IsRequired()
                  .HasMaxLength(100);
            entity.Property(a => a.Description)
                  .HasMaxLength(500);
            entity.Property(a => a.Status)
                  .HasConversion<string>()
                  .HasMaxLength(20);
            entity.HasIndex(a => a.Name).IsUnique();
        });
    }
}
