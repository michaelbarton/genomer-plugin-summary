require 'spec_helper'
require 'genomer-plugin-summary/format'

describe GenomerPluginSummary::Format do

  subject do
    o = Object.new
    o.extend described_class
    o.table(data,options.merge(:output => output))
  end

  describe "#table" do

    let(:data) do
      [['Contigs (#)',1.0],
        :separator,
        ['Gaps (#)',0]]
    end

    context "passed no output option" do

      let(:output) do
        nil
      end

      context "without any addtional options" do

        let(:options) do
          {}
        end

        it do
          should ==<<-EOS.unindent!
        +-------------+-----+
        | Contigs (#) | 1.0 |
        +-------------+-----+
        | Gaps (#)    | 0   |
        +-------------+-----+
          EOS
        end
      end

      context "the header option" do

        let(:options) do
          {:title => 'Scaffold' }
        end

        it do
          should ==<<-EOS.unindent!
      +-------------+-----+
      |     Scaffold      |
      +-------------+-----+
      | Contigs (#) | 1.0 |
      +-------------+-----+
      | Gaps (#)    | 0   |
      +-------------+-----+
          EOS
        end

      end

      context "with the justification option" do

        let(:options) do
          {:justification => {
            0 => :left,
            1 => :right
          }}
        end

        it do
          should ==<<-EOS.unindent!
      +-------------+-----+
      | Contigs (#) | 1.0 |
      +-------------+-----+
      | Gaps (#)    |   0 |
      +-------------+-----+
          EOS
        end
      end

      context "with the width option" do

        let(:options) do
          {:width         => { 0 => 15, 1 => 10 },
            :justification => { 1 => :right }}
        end

        it do
          should ==<<-EOS.unindent!
      +-----------------+------------+
      | Contigs (#)     |        1.0 |
      +-----------------+------------+
      | Gaps (#)        |          0 |
      +-----------------+------------+
          EOS
        end

      end

      context "with the format option" do

        let(:options) do
          {:format => { 1 => '%#.2f'}}
        end

        it do
          should ==<<-EOS.unindent!
      +-------------+------+
      | Contigs (#) | 1.00 |
      +-------------+------+
      | Gaps (#)    | 0.00 |
      +-------------+------+
          EOS
        end

      end

      context "with the format option as a lambda" do

        let(:options) do
          {:format => { 1 => lambda{|i| i.class == Float ? sprintf('%#.2f',i) : i }}}
        end

        it do
          should ==<<-EOS.unindent!
      +-------------+------+
      | Contigs (#) | 1.00 |
      +-------------+------+
      | Gaps (#)    | 0    |
      +-------------+------+
          EOS
        end

      end

      context "with the header option" do

        let(:options) do
          {:headers => ['One','Two']}
        end

        it do
          should ==<<-EOS.unindent!
      +-------------+-----+
      |     One     | Two |
      +-------------+-----+
      | Contigs (#) | 1.0 |
      +-------------+-----+
      | Gaps (#)    | 0   |
      +-------------+-----+
          EOS
        end

      end

    context "with the header and width options but no data" do

      let(:options) do
        {:headers => ['One','Two'],
         :width   => { 0 => 15, 1 => 10 }}
      end

      let(:data) do
        []
      end

      it do
        should ==<<-EOS.unindent!
      +-----------------+------------+
      |       One       |    Two     |
      +-----------------+------------+
      +-----------------+------------+
        EOS
      end

    end

  end

    context "passed the csv output option" do

      let(:output) do
        'csv'
      end

      context "without any additional options" do

        let(:options) do
          {}
        end

        it do
          should ==<<-EOS.unindent!
            contigs_#,1.0
            gaps_#,0
          EOS
        end
      end

      context "with the justification option" do

        let(:options) do
          {:justification => {
            0 => :left,
            1 => :right
          }}
        end

        it do
          should ==<<-EOS.unindent!
            contigs_#,1.0
            gaps_#,0
          EOS
        end
      end

      context "with the width option" do

        let(:options) do
          {:width         => { 0 => 15, 1 => 10 },
           :justification => { 1 => :right }}
        end

        it do
          should ==<<-EOS.unindent!
            contigs_#,1.0
            gaps_#,0
          EOS
        end

      end

      context "with the header option" do

        let(:options) do
          {:headers => ['One','Two']}
        end

        it do
          should ==<<-EOS.unindent!
            one,two
            contigs_#,1.0
            gaps_#,0
          EOS
        end

      end

      context "with the format option" do

        let(:options) do
          {:format => { 1 => '%#.2f'}}
        end

        it do
          should ==<<-EOS.unindent!
            contigs_#,1.00
            gaps_#,0.00
          EOS
        end

      end

      context "with the format option as a lambda" do

        let(:options) do
          {:format => { 1 => lambda{|i| i.class == Float ? sprintf('%#.2f',i) : i }}}
        end

        it do
          should ==<<-EOS.unindent!
            contigs_#,1.00
            gaps_#,0
          EOS
        end

      end

    end

  end

end
