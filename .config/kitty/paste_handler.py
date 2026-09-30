from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return
    if window.text_for_selection():
        window.copy_to_clipboard()
        window.screen.clear_selection()
    else:
        boss.paste_from_clipboard()


handle_result.no_ui = True