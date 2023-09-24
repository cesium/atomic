import EditorJS from "@editorjs/editorjs";
import Header from "@editorjs/header";
import Link from "@editorjs/link";
import SimpleImage from "@editorjs/simple-image";
import Checklist from "@editorjs/checklist";
import Embed from "@editorjs/embed";
import Table from "@editorjs/table";

// TODO: add link fetching

export const Editor = {
    mounted() {
        var editor = undefined
        this.handleEvent("init-editor", ({data, read_only}) => {
            editor = new EditorJS({
                holder: this.el.id,
                data: data,
                readOnly: read_only,
                tools: {
                    header: Header,
                    link: Link,
                    simpleImage: SimpleImage,
                    table: Table,
                    checklist: Checklist,
                    embed: {
                        class: Embed,
                        config: {
                            services: {
                                youtube: true,
                                twitter: true,
                                instagram: true,
                                miro: true
                            },
                        },
                    }
                },
            })
        })
        this.handleEvent("swap-view-mode", () => editor.readOnly.toggle())
        this.handleEvent("send-saved-data", ({params, selector}) => editor.save().then((outputData) => this.pushEventTo(selector, "save-data", {data: outputData, params: params})))
    }
}