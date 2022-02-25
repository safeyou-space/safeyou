import {ChangeDetectorRef, Component, OnDestroy, OnInit, ViewChild} from '@angular/core';
import { ModalDirective } from 'ngx-bootstrap/modal';
import {BehaviorSubject, Subscription} from 'rxjs';
import { SocketConnectionService } from 'src/app/shared/socketConnection.service';
import {RequestService} from "../../shared/request.service";

@Component({
  selector: 'app-default-layout',
  templateUrl: './default-layout.component.html',
  styleUrls: ['./default-layout.component.css']
})
export class DefaultLayoutComponent implements OnInit, OnDestroy {
  @ViewChild('infoModal') autoShownModal: any = ModalDirective;
  data;
  subscriptionLoading!: Subscription;
  loading: any = false;

  constructor(public socketConnect: SocketConnectionService,
              public requestService: RequestService,
              private cdRef: ChangeDetectorRef) { }


  ngOnInit(): void {
    this.subscriptionLoading = this.requestService.loading.subscribe((data) => {
      if (data && data['isLoading'] && data['reqCount'] === 1) {
        this.loading = data['isLoading'];
        this.cdRef.detectChanges();
      }
      if (data && data['reqCount'] === 0) {
        this.loading = data['isLoading'];
        this.cdRef.detectChanges();
      }
    });

    setTimeout(() => {
        this.socketConnect.connect();
    }, 0);

    this.socketConnect.helpSignal.subscribe(res => {
      if (res) {
        this.data = res;
        setTimeout(() => {
        this.autoShownModal.showModal();

        }, 0);
      }
    })

  }

  ngOnDestroy() {
    this.socketConnect.forDashboard = new BehaviorSubject<boolean>(false);
    this.socketConnect.invokeEvent = new BehaviorSubject<boolean>(false);
  }

  toggleMenu(main) {
    main.classList.toggle('margin-left-toggle');
  }
}
