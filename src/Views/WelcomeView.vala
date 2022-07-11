/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.Views.WelcomeView : Gtk.Grid {

    public unowned CHIP8.MainWindow main_window { get; construct; }

    public WelcomeView (CHIP8.MainWindow main_window) {
        Object (
            expand: true,
            main_window: main_window
        );
    }

    construct {
        var welcome = new Granite.Widgets.Welcome ("Welcome to CHIP-8", "A CHIP-8 emulator");
        welcome.append ("folder-open", "Choose a ROM", "Load a ROM file to play");

        add (welcome);

        welcome.activated.connect ((index) => {
            switch (index) {
                default:
                    CHIP8.ActionManager.action_from_group (CHIP8.ActionManager.ACTION_OPEN, main_window.get_action_group ("win"));
                    break;
            }
        });
    }

}
