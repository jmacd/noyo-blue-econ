import * as Inputs from "npm:@observablehq/inputs";

export const timelist = [
  ["1 Week", 7],
  ["2 Weeks", 14],
  ["1 Month", 30],
  ["2 Months", 60],
  ["3 Months", 90],
  ["6 Months", 180],
  ["12 Months", 365],
];

export async function timepicker() {
  return Inputs.radio(
    new Map(timelist),
    {
                value: 7, 
                label: "Time range", 
    }
  )
}
