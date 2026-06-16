from notion_client import Client
from dotenv import load_dotenv, dotenv_values

load_dotenv()

nc = Client(auth=dotenv_values()["NOTION_TOKEN"])

new_page = nc.pages.create(
    parent={
        "page_id":dotenv_values()["PAGE_ID"]
    },
    properties={
        "title": {
            "title": [
                {"text": {
                    "content": "Sub Page"
                }}
            ]
        }
    }
)

nc.blocks.children.append(
    block_id=new_page["id"],
    children=[
        {
            "object": "block",
            "type": "paragraph",
            "paragraph": {
                "rich_text": [
                    {
                        "type": "text",
                        "text": {
                            "content": "this is a sub page"
                        }
                    }
                ]
            }
        }
    ]
)