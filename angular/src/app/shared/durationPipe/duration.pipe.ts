import { Pipe, PipeTransform } from '@angular/core';
import {HelperService} from "../helper.service";

@Pipe({
  name: 'duration'
})
export class DurationPipe implements PipeTransform {
  constructor(public helperService: HelperService) {
  }

  transform(value: number, ...args: unknown[]): unknown {
    if (value > 60) {
      return `${Math.floor(value / 60)}:${value % 60} ${this.helperService.translation?.minute}`
    } else {
      return `${value} ${this.helperService.translation?.second}`;
    }
  }

}
