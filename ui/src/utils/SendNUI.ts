import { browserMode, resName } from '@store/stores'

/**
* @param eventName - The endpoint eventname to target
* @param data - Data you wish to send in the NUI Callback
*
* @return returnData - A promise for the data sent back by the NuiCallbacks CB argument
*/

let isBrowserMode = false;
browserMode.subscribe((value) => {
  isBrowserMode = value;
});

let debugResName = "";
resName.subscribe((value) => {
  debugResName = value;
});

export async function SendNUI<T = any>(
  eventName: string,
  data: unknown = {},
  debugReturn?: T
): Promise<T> {
  if (isBrowserMode == true && debugReturn) {
    return Promise.resolve(debugReturn as T)
  }
  const options = {
    method: "post",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify(data),
  };

  const resourceName = (window as any).GetParentResourceName
    ? (window as any).GetParentResourceName()
    : debugResName;

    if (isBrowserMode) return debugReturn || {} as T;

    const resp: Response = await fetch(`https://${resourceName}/${eventName}`, options);
    return await resp.json()
}