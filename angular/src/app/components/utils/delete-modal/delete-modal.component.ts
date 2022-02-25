import {Component, EventEmitter, OnInit, Output, ViewChild} from '@angular/core';
import {BsModalRef, BsModalService} from "ngx-bootstrap/modal";
import {HelperService} from "../../../shared/helper.service";

@Component({
  selector: 'app-delete-modal',
  templateUrl: './delete-modal.component.html',
  styleUrls: ['./delete-modal.component.css']
})
export class DeleteModalComponent implements OnInit {

  @ViewChild('delete_template') el;
  @Output() confirmDelete = new EventEmitter<number>();
  modalRef!: BsModalRef;
  itemId!: number;

  constructor(private modalService: BsModalService,
              public helperService: HelperService) {
  }

  ngOnInit() {
  }

  deleteModal(id: number) {
    this.itemId = id;
    this.modalRef = this.modalService.show(this.el, {class: 'modal-sm'});
  }

  confirm(): void {
    this.confirmDelete.emit(this.itemId);
  }

  decline(): void {
    this.modalRef.hide();
  }


}
