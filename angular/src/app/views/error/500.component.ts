import {Component, ElementRef} from '@angular/core';

@Component({
  templateUrl: '500.component.html',
  styleUrls: ['./500.component.css']
})
export class P500Component {

  sc: any;

  constructor(public el: ElementRef) {
    this.sc = document.createElement('script');
    this.sc.type = 'text/javascript';
    this.sc.innerHTML = 'render_error = new Vivus(\'render_error\', {type: \'oneByOne\', duration: 500});';
    this.el.nativeElement.appendChild(this.sc);
  }

}
