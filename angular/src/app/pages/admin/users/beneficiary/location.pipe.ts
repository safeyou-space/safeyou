import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'location'
})
export class LocationPipe implements PipeTransform {

  transform(value: any, ...args: unknown[]): unknown {
    if (!value) {
      return '';
    }
    let str;
    str = value.message.split('\n');
    str = str[3].split('<br/>');
    str= str[0];
    return str;
  }

}
