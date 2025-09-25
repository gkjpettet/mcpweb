# mcpweb
A MCP server for searching the web, written in Xojo.

## Usage
Build the project and place the built components in the desired location on your system. I'm on a Mac and I place it in my `Users` folder: `/Users/garry/mcp-servers/mcpweb`.

In your MCP client application (e.g. LM Studio, Claude Desktop, etc), follow the instructions on how to add an MCP server to the application. This usually involves editing some sort of `mcp.json` file.

`mcpweb` currently only supports searching the web using [Kagi] and so it requires an `--apikey` command line argument containing a valid API key for Kagi. This requires a subscription but in my opinion is worth it.

You can also pass a `--verbose` flag to `mcpweb` which will instruct it to output detailed logging to `stderr`.

Here is what my LM Studio `mcp.json` file looks like (API key redacted):

```json
{
  "mcpServers": {
    "mcpweb": {
      "command": "/Users/garry/mcp-servers/mcpweb/mcpweb",
      "args": [
        "--apikey",
        "YOUR_API_KEY_HERE"
      ]
    }
  }
}
```

Once you've informed your MCP client about the server, you normally have to restart the client to finalise things. Once that's done, you're local LLM will use `mcpweb` to search the web using Kagi.

Hopefully looking at the code will demonstrate how easy it is to build your own tools to use with LLMs using Xojo.

[Kagi]: https://kagi.com
