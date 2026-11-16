import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ContactReplyComponent } from './contact-reply.component';

describe('ContactReplyComponent', () => {
  let component: ContactReplyComponent;
  let fixture: ComponentFixture<ContactReplyComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ContactReplyComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ContactReplyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
