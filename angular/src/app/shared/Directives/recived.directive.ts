import { AfterViewInit, Directive, ElementRef, EventEmitter, Host, Input, OnDestroy, Output } from "@angular/core";
import { environment } from "src/environments/environment.prod";
import { SocketConnectionService } from "../socketConnection.service";

@Directive({
  selector: "[enterTheViewportNotifier]"
})
export class RecivedDirective implements AfterViewInit, OnDestroy {
  @Output() visibilityChange: EventEmitter<string> = new EventEmitter<string>();
  @Input('enterTheViewportNotifier') event: any;

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
        if (entry.intersectionRatio > 0) {
          this.socketConnect.skyp += 30;
          this.socketConnect.getMessages(this.socketConnect.skyp);
        }
      }
      if (entry.target.parentNode.className.includes("message_you")) {
        if (entry.isIntersecting) {
          delete entries[entry];
          this.event['recived'] = true;
          for (let recived of this.event.message_receivers) {
            if (recived.user_id != this.socketConnect.myUserId) {
              if (recived.received_type !== 2) {
                this.socketConnect.socket.emit('signal', environment.SIGNAL_M_RECEIVED, {
                  received_type: this.event['recived'] ? 2 : 1,
                  received_message_id: this.event.message_id,
                  received_room_id: this.socketConnect.active
                });
              }
            }
          }
        }
      }


    });
  };
}
