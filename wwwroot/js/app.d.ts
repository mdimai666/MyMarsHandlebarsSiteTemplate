declare class App {
    private _actions: Array<() => void>;

    domReady(callback: () => void): void;
    trigggerLoad(): void;
}

declare const app: App;
