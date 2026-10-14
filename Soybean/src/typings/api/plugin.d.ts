declare namespace Api {
  namespace System {
    type PluginItem = {
      name: string;
      title: string;
      version: string;
      author: string;
      installed: boolean;
      enabled: boolean;
      status_text: string;
      dependencies?: Record<string, string> | string[] | null;
    };

    type PluginCreateParams = {
      name: string;
      title?: string;
      author?: string;
      description?: string;
    };

    type PluginInstallParams = {
      name: string;
      auto_install_dependencies?: boolean;
      force?: boolean;
    };

    type PluginUninstallParams = {
      name: string;
      force?: boolean;
    };
  }
}
