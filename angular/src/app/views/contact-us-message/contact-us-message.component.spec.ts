import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ContactUsMessageComponent } from './contact-us-message.component';

describe('ContactUsMessageComponent', () => {
  let component: ContactUsMessageComponent;
  let fixture: ComponentFixture<ContactUsMessageComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ContactUsMessageComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ContactUsMessageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
