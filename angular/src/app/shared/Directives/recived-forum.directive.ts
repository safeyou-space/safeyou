import { AfterViewInit, Directive, ElementRef, EventEmitter, Host, Input, OnDestroy, Output } from "@angular/core";
import { SocketConnectionService } from "../socketConnection.service";

@Directive({
  selector: '[appRecivedForum]'
})
export class RecivedForumDirective implements AfterViewInit, OnDestroy {
  @Output() visibilityChange: EventEmitter<string> = new EventEmitter<string>();
  @Input('appRecivedForum') event: any;

  private _observer: IntersectionObserver | undefined;

  constructor(@Host() private _elementRef: ElementRef, public socketConnect: SocketConnectionService) { }

  ngAfterViewInit(): void {
    const options = {
      root: null,
      rootMargin: "0px",
      threshold: 0.0
    };

    this._observer = new IntersectionObserver(this._callback, options);

    this._observer.observe(this._elementRef.nativeElement);

  }

  ngOnDestroy() {
    if (this._observer)
      this._observer.disconnect();
  }


  private _callback = (entries, observer) => {
 
    entries.forEach(entry => {

      if (this.socketConnect.scrollBottom == true && this.event == 'pagechange' && this.socketConnect.response == 1) {
        if (entry.intersectionRatio > 0 && this.socketConnect.messageFromNotificationUrlPagination) {
          this.socketConnect.skyp += 30;
          this.socketConnect.getMessages(this.socketConnect.skyp);
        }
      }
    });
  };
}
