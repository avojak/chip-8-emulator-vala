/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.ActionManager : GLib.Object {

    public const string ACTION_PREFIX = "win.";
    public const string ACTION_HELP = "action_help";
    public const string ACTION_PREFERENCES = "action_preferences";
    public const string ACTION_OPEN = "action_open";
    public const string ACTION_QUIT = "action_quit";

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_HELP, action_help },
        { ACTION_PREFERENCES, action_preferences },
        { ACTION_OPEN, action_open },
        { ACTION_QUIT, action_quit }
    };

    private static Gee.MultiMap<string, string> accelerators;

    public unowned CHIP8.Application application { get; construct; }
    public unowned CHIP8.MainWindow window { get; construct; }

    private GLib.SimpleActionGroup action_group;

    public ActionManager (CHIP8.Application application, CHIP8.MainWindow window) {
        Object (
            application: application,
            window: window
        );
    }

    static construct {
        accelerators = new Gee.HashMultiMap<string, string> ();
        accelerators.set (ACTION_HELP, "<Control>h");
        accelerators.set (ACTION_PREFERENCES, "<Shift><Control>p");
        accelerators.set (ACTION_OPEN, "<Control>o");
        accelerators.set (ACTION_QUIT, "<Control>q");
    }

    construct {
        action_group = new GLib.SimpleActionGroup ();
        action_group.add_action_entries (ACTION_ENTRIES, this);
        window.insert_action_group ("win", action_group);

        foreach (var action in accelerators.get_keys ()) {
            var accelerators_array = accelerators[action].to_array ();
            accelerators_array += null;
            application.set_accels_for_action (ACTION_PREFIX + action, accelerators_array);
        }
    }

    public static void action_from_group (string action_name, ActionGroup action_group, Variant? parameter = null) {
        action_group.activate_action (action_name, parameter);
    }

    private void action_help () {
        window.show_controls_dialog ();
    }

    private void action_preferences () {
        window.show_preferences_dialog ();
    }

    private void action_open () {
        window.show_rom_popover ();
    }

    private void action_quit () {
        window.before_destroy ();
    }

}
