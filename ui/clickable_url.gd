extends RichTextLabel


func _on_meta_clicked(meta):
	OS.shell_open(str(meta))
