import { writable } from "svelte/store";

export const visibility = writable(false);
export const browserMode = writable(false);


export const dataStore = writable({});
export const cart = writable([]);
export const isCart = writable(false);
export const resName = writable("");