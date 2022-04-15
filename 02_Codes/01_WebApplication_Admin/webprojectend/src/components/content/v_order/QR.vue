<template>
  <div id="QR_Code">
    <!-- add modal Add -->
    <b-modal id="QRCode" title="QR Code" size="sm" hide-footer>
      <form class="needs-validation form-group">
        <div
          class="row"
          v-for="(production, index) in editModal.content.production"
          :key="index"
        >
          <div class="col">
            <div class="row">
              <div class="col text-center">
                <h5>{{ production.v_name }}</h5>
              </div>
            </div>
            <div class="row">
              <div class="col text-center" style="">
                <vue-qr :text="$QrUrl + production.pd_id" :size="140" :margin="0"></vue-qr>
              </div>
            </div>
            <div class="row mt-2">
              <div class="col text-center">
                <div class="input-group">
                  <span class="input-group-text">จำนวนแถว:</span>
                  <input
                    type="number"
                    aria-label="number"
                    name="number"
                    v-validate="'required'"
                    v-model.number="number"
                    :class="{
                      input: true,
                      'is-invalid': errors.has('number'),
                    }"
                    min="1"
                    class="form-control"
                  />
                </div>
              </div>
            </div>
            <div class="row mb-4 mt-2">
              <div class="col text-center">
                <button
                  type="button"
                  class="btn btn-info"
                  @click="generateReport(production.pd_id, production.v_name)"
                >
                  พิมพ์
                </button>
              </div>
            </div>
          </div>
        </div>
      </form>
      <b-button class="mt-3" block @click="$bvModal.hide('QRCode')"
        >ปิด</b-button
      >
    </b-modal>

    <div>
      <vue-html2pdf
        :show-layout="false"
        :float-layout="true"
        :enable-download="false"
        :preview-modal="true"
        :paginate-elements-by-height="1400"
        :filename="name"
        :pdf-quality="2"
        :manual-pagination="true"
        v-if="id"
        pdf-format="a4"
        pdf-orientation="portrait"
        pdf-content-width="800px"
        
        ref="html2Pdf"
      >
        <section slot="pdf-content">
          <div class="" v-for="i in number" :key="i">
            <div class="row">
              <div
                class="col m-2 mb-3 text-center"
                v-for="index in 4"
                :key="index"
              >
                <h6 style="font-size: 15px; margin: 0">{{ name }}</h6>
                <vue-qr :text="$QrUrl + id" :size="133" :margin="0"></vue-qr>
                <h6 style="font-size: 10px; margin: 0">{{ id }}</h6>
              </div>
            </div>
          </div>
        </section>
      </vue-html2pdf>
    </div>
  </div>
</template>

<script>
import VueHtml2pdf from "vue-html2pdf";
import VueQr from 'vue-qr'
export default {
  components: {VueQr, VueHtml2pdf },
  props: {
    editModal: Object,
  },
  data() {
    return {
      id: "",
      number: 5,
      name: "",
    };
  },

  async mounted() {},

  methods: {
    generateReport(id, name) {
      this.id = id;
      this.name = name;
      setTimeout(() => this.$refs.html2Pdf.generatePdf(), 30);
    },
  },
};
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Itim&display=swap');
h5,h6{
  font-family: 'Itim', cursive;
}

.table th,
.table td {
  vertical-align: middle;
}
</style>
