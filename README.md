# NetBox MCP Server

This is a simple read-only [Model Context Protocol](https://modelcontextprotocol.io/) server for NetBox.  It enables you to interact with your data in NetBox directly via LLMs that support MCP.

## Tools

| Tool | Description |
|------|-------------|
| get_objects | Retrieves NetBox objects based on their type and filters |
| get_object_by_id | Gets detailed information about a specific NetBox object by its ID |
| get_changelogs | Retrieves change history records (audit trail) based on filters |

## Supported Object Types

The server supports all core NetBox objects plus the **netbox-inventory plugin**:

### Core NetBox Objects
- **DCIM**: devices, sites, racks, cables, interfaces, power-feeds, etc.
- **IPAM**: ip-addresses, prefixes, vlans, vrfs, asns, etc.
- **Circuits**: circuits, providers, circuit-types, etc.
- **Virtualization**: virtual-machines, clusters, vm-interfaces, etc.
- **Tenancy**: tenants, contacts, tenant-groups, etc.
- **VPN**: tunnels, ike-policies, ipsec-policies, etc.
- **Wireless**: wireless-lans, wireless-links, etc.
- **Extras**: tags, custom-fields, webhooks, etc.

### Inventory Plugin (netbox-inventory)
- **Assets**: assets, inventory-item-types, inventory-item-groups
- **Supply Chain**: suppliers, purchases, deliveries  
- **Audit & Compliance**: audit-flows, audit-flowpages, audit-trails, etc.

## Usage

### Option 1: Local Installation

1. Create a read-only API token in NetBox with sufficient permissions for the tool to access the data you want to make available via MCP.

2. Install dependencies: `uv add -r requirements.txt`

3. Verify the server can run: `NETBOX_URL=https://netbox.example.com/ NETBOX_TOKEN=<your-api-token> uv run server.py`

4. Add the MCP server configuration to your LLM client.  For example, in Claude Desktop (Mac):

```json
{
  "mcpServers": {
        "netbox": {
            "command": "uv",
            "args": [
                "--directory",
                "/path/to/netbox-mcp-server",
                "run",
                "server.py"
            ],
            "env": {
                "NETBOX_URL": "https://netbox.example.com/",
                "NETBOX_TOKEN": "<your-api-token>"
            }
        }
}
```
> On Windows, use full, escaped path to your instance, such as `C:\\Users\\myuser\\.local\\bin\\uv` and `C:\\Users\\myuser\\netbox-mcp-server`. 
> For detailed troubleshooting, consult the [MCP quickstart](https://modelcontextprotocol.io/quickstart/user).

### Option 2: Docker Container

1. Create a read-only API token in NetBox with sufficient permissions for the tool to access the data you want to make available via MCP.

2. Build the Docker image: `docker build -t netbox-mcp-server .`

3. Add the MCP server configuration to your LLM client. For example, in Claude Desktop:

```json
{
  "mcpServers": {
        "netbox": {
            "command": "docker",
            "args": [
                "run",
                "--rm",
                "-i",
                "-e",
                "NETBOX_URL=https://netbox.example.com/",
                "-e",
                "NETBOX_TOKEN=<your-api-token>",
                "netbox-mcp-server"
            ],
            "env": {}
        }
}
```

4. Use the tools in your LLM client.  For example:

```text
> Get all devices in the 'Equinix DC14' site
...
> Tell me about my IPAM utilization
...
> What Cisco devices are in my network?
...
> Show me all stored network modules and their serial numbers
...
> List all suppliers and their recent deliveries
...
> Who made changes to the NYC site in the last week?
...
> Show me all configuration changes to the core router in the last month
```

## Development

Contributions are welcome!  Please open an issue or submit a PR.

## License

This project is licensed under the Apache 2.0 license.  See the LICENSE file for details.
