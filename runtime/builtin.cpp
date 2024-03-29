#include "builtin.h"

const JSErrorFormatString *GetErrorMessage(void *userRef, unsigned errorNumber) {
  if (errorNumber > 0 && errorNumber < JSErrNum_Limit) {
    return &js_ErrorFormatString[errorNumber];
  }

  return nullptr;
}

std::optional<std::span<uint8_t>> value_to_buffer(JSContext *cx, JS::HandleValue val,
                                                  const char *val_desc) {
  if (!val.isObject() ||
      !(JS_IsArrayBufferViewObject(&val.toObject()) || JS::IsArrayBufferObject(&val.toObject()))) {
    JS_ReportErrorNumberUTF8(cx, GetErrorMessage, nullptr, JSMSG_INVALID_BUFFER_ARG, val_desc,
                             val.type());
    return std::nullopt;
  }

  JS::RootedObject input(cx, &val.toObject());
  uint8_t *data;
  bool is_shared;
  size_t len = 0;

  if (JS_IsArrayBufferViewObject(input)) {
    js::GetArrayBufferViewLengthAndData(input, &len, &is_shared, &data);
  } else {
    JS::GetArrayBufferLengthAndData(input, &len, &is_shared, &data);
  }

  return std::span(data, len);
}

bool RejectPromiseWithPendingError(JSContext *cx, HandleObject promise) {
  RootedValue exn(cx);
  if (!JS_IsExceptionPending(cx) || !JS_GetPendingException(cx, &exn)) {
    return false;
  }
  JS_ClearPendingException(cx);
  return JS::RejectPromise(cx, promise, exn);
}

JSObject *PromiseRejectedWithPendingError(JSContext *cx) {
  RootedObject promise(cx, JS::NewPromiseObject(cx, nullptr));
  if (!promise || !RejectPromiseWithPendingError(cx, promise)) {
    return nullptr;
  }
  return promise;
}

enum class Mode { PreWizening, PostWizening };

Mode execution_mode = Mode::PreWizening;

bool hasWizeningFinished() { return execution_mode == Mode::PostWizening; }

bool isWizening() { return execution_mode == Mode::PreWizening; }

void markWizeningAsFinished() { execution_mode = Mode::PostWizening; }
