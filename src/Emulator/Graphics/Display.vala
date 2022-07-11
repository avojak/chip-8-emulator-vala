/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.Graphics.Display : Gtk.Grid {

    public unowned CHIP8.Graphics.PPU ppu { get; construct; }

    private const int BASE_SCALING = 10; // Base scaling factor to have a reasonable default display size

    public Display (CHIP8.Graphics.PPU ppu) {
        Object (
            expand: true,
            ppu: ppu
        );
    }

    construct {
        var drawing_area = new Gtk.DrawingArea ();
        drawing_area.width_request = CHIP8.Graphics.PPU.WIDTH * BASE_SCALING;
        drawing_area.height_request = CHIP8.Graphics.PPU.HEIGHT * BASE_SCALING;
        drawing_area.draw.connect (on_draw);

        add (drawing_area);

        ppu.display_data_changed.connect (queue_draw);

        show_all ();
    }

    private bool on_draw (Gtk.Widget da, Cairo.Context ctx) {
        ctx.save ();
        for (int row = 0; row < CHIP8.Graphics.PPU.HEIGHT; row++) {
            for (int col = 0; col < CHIP8.Graphics.PPU.WIDTH; col++) {
                int pixel_color = ppu.get_pixel (col, row); // * 255;
                var palette_color = get_palette_color (pixel_color);
                ctx.set_source_rgb (palette_color.red, palette_color.green, palette_color.blue);
                ctx.new_path ();
                ctx.move_to (col * BASE_SCALING, row * BASE_SCALING);
                ctx.rel_line_to (BASE_SCALING, 0);
                ctx.rel_line_to (0, BASE_SCALING);
                ctx.rel_line_to (-BASE_SCALING, 0);
                ctx.close_path ();
                ctx.fill ();
            }
        }
        ctx.restore ();
        return true;
    }

    /**
     * Maps the 0 or 1 pixel value to the desired display palette color.
     */
    private Gdk.RGBA get_palette_color (int pixel_color) {
        var palette_color = Gdk.RGBA ();
        switch (pixel_color) {
            case 0:
                palette_color.parse (CHIP8.Application.settings.background_color);
                break;
            case 1:
                palette_color.parse (CHIP8.Application.settings.foreground_color);
                break;
            default:
                assert_not_reached ();
        }
        return palette_color;
    }

}
